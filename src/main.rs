use macroquad::prelude::*;
use macroquad::audio;

static CHINESE_FONT_BYTES: &[u8] = include_bytes!("C:\\Windows\\Fonts\\msyh.ttc");

// 方块结构体 - 表示游戏中的可移动方块
#[derive(Clone, PartialEq)]
struct Block {
    x: f32,              // 方块x坐标
    y: f32,              // 方块y坐标
    velocity_x: f32,     // x方向速度
    velocity_y: f32,     // y方向速度
    size: f32,           // 方块大小
    number: i32,         // 方块上的数字
    gravity: f32,        // 重力加速度
    is_stopped: bool,    // 方块是否已停止（碰到地面）
    is_merged: bool,     // 方块是否已被合成
}

impl Block {
    // 根据数字获取颜色
    fn get_color(&self) -> Color {
        match self.number {
            2 => Color::from_rgba(220, 220, 220, 255),  // 浅灰色
            4 => Color::from_rgba(150, 200, 100, 255),  // 绿色
            8 => Color::from_rgba(100, 150, 200, 255),  // 蓝色
            16 => Color::from_rgba(200, 100, 200, 255), // 紫色
            32 => Color::from_rgba(200, 150, 100, 255), // 橙色
            64 => Color::from_rgba(200, 100, 100, 255), // 红色
            _ => WHITE,
        }
    }

    // 创建新方块的构造函数
    // 创建新方块的构造函数
    fn new(x: f32, y: f32, velocity_x: f32, velocity_y: f32) -> Self {
        // 随机生成一个数字：2、4、8、16、32、64
        let numbers = [2, 4, 8, 16, 32, 64];
        let number = numbers[rand::gen_range(0, numbers.len())];
        
        Self {
            x,
            y,
            velocity_x,
            velocity_y,
            size: 40.0,  // 方块大小增大到40像素
            number,      // 使用随机生成的数字
            gravity: 500.0, // 重力加速度，影响方块下落
            is_stopped: false, // 初始状态为未停止
            is_merged: false, // 初始状态为未合成
        }
    }

    // 更新方块状态（位置、速度等）
    fn update(&mut self, dt: f32, game_width: f32, game_height: f32, left_width: f32, grid_size: f32) {
        // 如果方块已经停止，不再更新位置和速度
        if self.is_stopped {
            return;
        }
        
        // 根据速度更新位置
        self.x += self.velocity_x * dt;
        self.y += self.velocity_y * dt;
        
        // 应用重力效果，让方块向下加速
        self.velocity_y += self.gravity * dt;
        
        // 边界碰撞检测 - 只检测左右边界（方块使用中心坐标）
        if self.x < self.size / 2.0 || self.x > game_width - self.size / 2.0 {
            // 确保方块在边界内
            self.x = self.x.max(self.size / 2.0).min(game_width - self.size / 2.0);
            self.velocity_x = 0.0; // 碰到边界水平速度归零
        }
        
        // 处理超出边界和碰到地面的情况
        // 右边区域才需要处理停止
        if self.x >= left_width && self.y >= game_height - self.size / 2.0 {
            // 右边区域：碰到底部就立即停止
            self.velocity_x = 0.0;
            self.velocity_y = 0.0;
            self.is_stopped = true;
            
            // 计算当前方块中心点位于哪个网格
            let col = ((self.x - left_width) / grid_size).floor();
            let grid_x = left_width + (col + 0.5) * grid_size;
            let next_grid_x = left_width + (col + 1.5) * grid_size;
            
            // 确定应该放在哪个网格中（比较与左右两个网格的重叠面积）
            let dist_to_current = (self.x - grid_x).abs();
            let dist_to_next = (self.x - next_grid_x).abs();
            
            // 选择重叠面积最大的网格（距离最近的）
            let final_x = if dist_to_current <= dist_to_next {
                grid_x
            } else {
                next_grid_x
            };
            
            // 确保不会超出右边界
            self.x = final_x.max(left_width + self.size / 2.0).min(game_width - self.size / 2.0);
            // 放在地面上
            self.y = game_height - self.size / 2.0;
        }
    }

    // 检查两个方块是否碰撞
    fn check_collision(&self, other: &Block) -> bool {
        // 计算两个方块中心点之间的距离
        let dx = self.x - other.x;
        let dy = self.y - other.y;
        let distance = (dx * dx + dy * dy).sqrt();
        
        // 如果距离小于两个方块半径之和，则发生碰撞
        let min_distance = (self.size + other.size) / 2.0;
        distance < min_distance
    }
    
    // 绘制方块
    fn draw(&self, scale_x: f32, scale_y: f32, offset_x: f32, offset_y: f32) {
        // 将游戏世界坐标转换为屏幕坐标
        let screen_x = self.x * scale_x + offset_x;
        let screen_y = self.y * scale_y + offset_y;
        let screen_size = self.size * scale_x.min(scale_y); // 使用较小的缩放比例保持方块形状
        
        // 确保方块位置稳定，避免闪烁
        let draw_x = (screen_x - screen_size / 2.0).round();
        let draw_y = (screen_y - screen_size / 2.0).round();
        
        // 绘制方块背景
        draw_rectangle(draw_x, draw_y, screen_size, screen_size, self.get_color());
        
        // 为所有停止的方块添加白色边框
        if self.is_stopped {
            draw_rectangle_lines(draw_x, draw_y, screen_size, screen_size, 2.0, WHITE);
        }
        
        // 绘制数字
        let text = self.number.to_string();
        let font_size = (screen_size * 0.5) as u16; // 数字大小为方块大小的一半
        
        // 计算文字大小
        let text_dims = measure_text(&text, None, font_size, 1.0);
        let text_x = draw_x + (screen_size - text_dims.width) / 2.0;
        let text_y = draw_y + (screen_size + text_dims.height) / 2.0;
        
        // 绘制数字（黑色，使其在任何颜色的背景上都清晰可见）
        draw_text(&text, text_x, text_y, font_size as f32, BLACK);
    }
}

// 游戏状态结构体 - 管理整个游戏的状态
struct GameState {
    blocks: Vec<Block>,  // 存储所有方块的向量
    launch_x: f32,      // 发射点的x坐标（游戏世界坐标）
    launch_y: f32,      // 发射点的y坐标（游戏世界坐标）
    game_width: f32,    // 游戏世界宽度（固定）
    game_height: f32,   // 游戏世界高度（固定）
    scale_x: f32,       // x方向缩放比例
    scale_y: f32,       // y方向缩放比例
    offset_x: f32,      // x方向偏移
    offset_y: f32,      // y方向偏移
    left_width: f32,    // 左边区域宽度
    grid_size: f32,     // 网格大小（与方块大小相同）
    grid_cols: i32,     // 网格列数
    grid_rows: i32,     // 网格行数
    font: Option<Font>, // 用于显示中文的字体
    score: i32,         // 游戏得分
    launch_sound: Option<macroquad::audio::Sound>, // 发射音效
    merge_sound: Option<macroquad::audio::Sound>,  // 合成音效
    clear_sound: Option<macroquad::audio::Sound>,  // 消除音效
}

impl GameState {
    // 创建新的游戏状态
    async fn new() -> Self {
        let game_width = 800.0;  // 固定的游戏世界宽度
        let game_height = 600.0; // 固定的游戏世界高度
        let left_width = game_width * 0.4;  // 左边区域占40%
        let grid_size = 40.0;   // 网格大小与方块大小相同
        let grid_cols = ((game_width - left_width) / grid_size) as i32;
        let grid_rows = ((game_height / grid_size) as f32).ceil() as i32;

        // 从内存中加载字体
        let font = load_ttf_font_from_bytes(CHINESE_FONT_BYTES).ok();
        
        // 加载音效
        let launch_sound = audio::load_sound("data/launch.wav").await.ok();
        let merge_sound = audio::load_sound("data/merge.wav").await.ok();
        let clear_sound = audio::load_sound("data/clear.wav").await.ok();

        Self {
            blocks: Vec::new(),  // 初始化空的方块列表
            launch_x: 50.0,     // 发射点距离左边缘50像素（游戏世界坐标）
            launch_y: game_height - 50.0, // 发射点距离底部50像素（游戏世界坐标）
            game_width,
            game_height,
            scale_x: 1.0,       // 初始缩放比例
            scale_y: 1.0,       // 初始缩放比例
            offset_x: 0.0,      // 初始偏移
            offset_y: 0.0,      // 初始偏移
            left_width,
            grid_size,
            grid_cols,
            grid_rows,
            font,              // 添加字体字段
            score: 0,          // 初始分数为0
            launch_sound,      // 发射音效
            merge_sound,       // 合成音效
            clear_sound,       // 消除音效
        }
    }
    
    // 更新缩放和偏移参数
    fn update_scaling(&mut self) {
        let screen_w = screen_width();
        let screen_h = screen_height();
        
        // 计算缩放比例，保持宽高比
        let scale_x = screen_w / self.game_width;
        let scale_y = screen_h / self.game_height;
        
        // 使用较小的缩放比例以保持宽高比
        self.scale_x = scale_x.min(scale_y);
        self.scale_y = self.scale_x;
        
        // 计算居中偏移
        self.offset_x = (screen_w - self.game_width * self.scale_x) / 2.0;
        self.offset_y = (screen_h - self.game_height * self.scale_y) / 2.0;
    }
    
    // 将游戏世界坐标转换为屏幕坐标
    fn world_to_screen(&self, world_x: f32, world_y: f32) -> (f32, f32) {
        let screen_x = world_x * self.scale_x + self.offset_x;
        let screen_y = world_y * self.scale_y + self.offset_y;
        (screen_x, screen_y)
    }
    
    // 将屏幕坐标转换为游戏世界坐标
    fn screen_to_world(&self, screen_x: f32, screen_y: f32) -> (f32, f32) {
        let world_x = (screen_x - self.offset_x) / self.scale_x;
        let world_y = (screen_y - self.offset_y) / self.scale_y;
        (world_x, world_y)
    }

    // 生成新方块 - 根据鼠标位置计算抛物线轨迹
    fn spawn_block(&mut self) {
        // 获取当前鼠标位置（屏幕坐标）
        let mouse_pos = mouse_position();
        // 将屏幕坐标转换为游戏世界坐标
        let (world_mouse_x, world_mouse_y) = self.screen_to_world(mouse_pos.0, mouse_pos.1);
        
        let dx = world_mouse_x - self.launch_x;  // 计算水平距离（游戏世界坐标）
        let dy = world_mouse_y - self.launch_y;  // 计算垂直距离（游戏世界坐标）
        
        // 计算抛物线初始速度
        let speed_multiplier = 0.8;  // 速度倍数，可以调整发射力度
        let velocity_x = dx * speed_multiplier;  // 水平速度
        let velocity_y = dy * speed_multiplier - 200.0; // 垂直速度（向上偏移形成抛物线）
        
        // 播放发射音效
        if let Some(sound) = &self.launch_sound {
            audio::play_sound(sound, audio::PlaySoundParams {
                looped: false,
                volume: 0.5,
            });
        }
        
        // 创建新方块并添加到列表中
        let block = Block::new(self.launch_x, self.launch_y, velocity_x, velocity_y);
        self.blocks.push(block);
    }

    // 更新游戏状态 - 每帧调用
    fn update(&mut self, dt: f32) {
        // 更新缩放和偏移参数
        self.update_scaling();
        
        // 更新所有方块的状态（使用游戏世界坐标）
        for block in &mut self.blocks {
            block.update(dt, self.game_width, self.game_height, self.left_width, self.grid_size);
        }
        
        // 处理方块之间的碰撞检测
        self.handle_block_collisions();
        
        // 处理方块合成
        self.handle_block_merge();
        
        // 移除被合成的方块
        self.blocks.retain(|block| !block.is_merged);
        
        // 检查并重置不稳定方块的状态
        self.check_unstable_blocks();
    }
    
    // 处理方块之间的碰撞检测
    fn handle_block_collisions(&mut self) {
        let block_count = self.blocks.len();
        
        // 使用双重循环检查所有方块对之间的碰撞
        for i in 0..block_count {
            for j in (i + 1)..block_count {
                // 检查两个方块是否碰撞
                if self.blocks[i].check_collision(&self.blocks[j]) {
                    // 计算碰撞方向
                    let dx = self.blocks[i].x - self.blocks[j].x;
                    let dy = self.blocks[i].y - self.blocks[j].y;
                    let is_vertical_collision = dy.abs() > dx.abs(); // 判断是否为竖直碰撞
                    
                    // 处理移动中的方块i
                    if !self.blocks[i].is_stopped {
                        self.blocks[i].velocity_x = 0.0; // 水平速度始终归零
                        
                        // 只有竖直碰撞且从上往下碰到已停止的方块时才停止
                        if is_vertical_collision && dy < 0.0 && self.blocks[j].is_stopped {
                            self.blocks[i].is_stopped = true;
                            self.blocks[i].velocity_y = 0.0;
                            self.blocks[i].x = self.blocks[j].x;
                            self.blocks[i].y = self.blocks[j].y - self.blocks[i].size;
                        }
                    }
                    
                    // 处理移动中的方块j
                    if !self.blocks[j].is_stopped {
                        self.blocks[j].velocity_x = 0.0; // 水平速度始终归零
                        
                        // 只有竖直碰撞且从上往下碰到已停止的方块时才停止
                        if is_vertical_collision && dy > 0.0 && self.blocks[i].is_stopped {
                            self.blocks[j].is_stopped = true;
                            self.blocks[j].velocity_y = 0.0;
                            self.blocks[j].x = self.blocks[i].x;
                            self.blocks[j].y = self.blocks[i].y - self.blocks[j].size;
                        }
                    }
                }
            }
        }
    }

    // 处理方块合成和消除
    fn handle_block_merge(&mut self) {
        let mut merged_indices = Vec::new();
        let mut new_blocks = Vec::new();
        let mut sixty_four_groups = Vec::new();

        // 第一步：找出所有相邻的64方块组
        for i in 0..self.blocks.len() {
            if !self.blocks[i].is_stopped || self.blocks[i].is_merged || self.blocks[i].number != 64 {
                continue;
            }

            let mut current_group = vec![i];
            let mut checked = vec![false; self.blocks.len()];
            checked[i] = true;

            // 使用DFS查找所有相连的64方块
            let mut stack = vec![i];
            while let Some(current) = stack.pop() {
                for j in 0..self.blocks.len() {
                    if !checked[j] && !self.blocks[j].is_merged && self.blocks[j].is_stopped && self.blocks[j].number == 64 {
                        let dx = (self.blocks[j].x - self.blocks[current].x).abs();
                        let dy = (self.blocks[j].y - self.blocks[current].y).abs();
                        let is_adjacent = (dx < 1.0 && dy <= self.grid_size + 1.0) || 
                                        (dy < 1.0 && dx <= self.grid_size + 1.0);

                        if is_adjacent {
                            current_group.push(j);
                            checked[j] = true;
                            stack.push(j);
                        }
                    }
                }
            }

            // 如果找到两个或以上相邻的64方块
            if current_group.len() >= 2 {
                sixty_four_groups.push(current_group);
            }
        }

        // 记录已处理过的64方块索引，防止重复计分
        let mut processed_indices = std::collections::HashSet::new();

        // 处理64方块组的消除和计分
        for group in sixty_four_groups {
            // 只处理未计分的方块
            for &index in &group {
                if processed_indices.insert(index) {
                    // 每消除一个未处理过的64方块加1分
                    self.score += 1;
                }
                self.blocks[index].is_merged = true;
            }
            
            // 播放消除音效
            if let Some(sound) = &self.clear_sound {
                audio::play_sound(sound, audio::PlaySoundParams {
                    looped: false,
                    volume: 0.5,
                });
            }
        }

        // 处理常规的方块合并
        for i in 0..self.blocks.len() {
            if !self.blocks[i].is_stopped || self.blocks[i].is_merged {
                continue;
            }
            
            for j in (i + 1)..self.blocks.len() {
                if !self.blocks[j].is_stopped || self.blocks[j].is_merged {
                    continue;
                }

                let dx = (self.blocks[j].x - self.blocks[i].x).abs();
                let dy = (self.blocks[j].y - self.blocks[i].y).abs();
                
                let is_adjacent = (dx < 1.0 && dy <= self.grid_size + 1.0) || 
                                (dy < 1.0 && dx <= self.grid_size + 1.0);

                if is_adjacent && 
                   self.blocks[i].number == self.blocks[j].number && 
                   self.blocks[i].number < 64 &&
                   !merged_indices.contains(&i) && 
                   !merged_indices.contains(&j) 
                {
                    // 选择较新的方块的位置作为合成位置
                    let new_x = self.blocks[j].x;
                    let new_y = self.blocks[j].y;
                    
                    let new_block = Block {
                        x: new_x,
                        y: new_y,
                        velocity_x: 0.0,
                        velocity_y: 0.0,
                        size: 40.0,
                        number: self.blocks[i].number * 2,
                        gravity: 500.0,
                        is_stopped: true,
                        is_merged: false,
                    };

                    // 播放合成音效
                    if let Some(sound) = &self.merge_sound {
                        audio::play_sound(sound, audio::PlaySoundParams {
                            looped: false,
                            volume: 0.5,
                        });
                    }

                    merged_indices.push(i);
                    merged_indices.push(j);
                    new_blocks.push(new_block);
                }
            }
        }

        // 标记要移除的合并方块
        for &index in &merged_indices {
            self.blocks[index].is_merged = true;
        }

        // 添加新合成的方块
        self.blocks.extend(new_blocks);
    }

    // 尝试移动右边区域的方块到最左或最右
    fn try_move_blocks(&mut self, direction: i32) {
        // 获取所有停止的方块
        let mut stopped_blocks: Vec<usize> = (0..self.blocks.len())
            .filter(|&i| self.blocks[i].is_stopped && self.blocks[i].x >= self.left_width)
            .collect();

        // 根据移动方向排序方块，确保正确的移动顺序
        if direction > 0 {
            // 向右移动时，从右到左处理方块
            stopped_blocks.sort_by(|&a, &b| self.blocks[b].x.partial_cmp(&self.blocks[a].x).unwrap());
        } else {
            // 向左移动时，从左到右处理方块
            stopped_blocks.sort_by(|&a, &b| self.blocks[a].x.partial_cmp(&self.blocks[b].x).unwrap());
        }

        for &i in &stopped_blocks {
            // 根据方向确定目标位置
            let target_x = if direction > 0 {
                // 最右边，减去一个网格宽度
                self.game_width - self.grid_size / 2.0
            } else {
                // 最左边
                self.left_width + self.grid_size / 2.0
            };

            // 计算移动方向上的移动步长
            let step = direction as f32 * self.grid_size;
            
            // 从当前位置开始逐步移动，直到不能移动为止
            let mut current_x = self.blocks[i].x;
            let mut last_valid_x = current_x;

            loop {
                current_x += step;
                
                // 检查是否超出目标位置
                if (direction > 0 && current_x > target_x) || 
                   (direction < 0 && current_x < target_x) {
                    current_x = target_x;
                }

                // 检查是否与其他方块冲突
                let mut has_collision = false;
                for j in 0..self.blocks.len() {
                    if i != j && self.blocks[j].is_stopped {
                        let dx = (current_x - self.blocks[j].x).abs();
                        let dy = (self.blocks[i].y - self.blocks[j].y).abs();
                        if dx < self.blocks[i].size && dy < self.blocks[i].size {
                            has_collision = true;
                            break;
                        }
                    }
                }

                if has_collision || current_x == target_x {
                    // 更新到最后一个有效位置
                    self.blocks[i].x = last_valid_x;
                    break;
                }

                last_valid_x = current_x;
                
                // 如果已经到达目标位置，停止移动
                if current_x == target_x {
                    self.blocks[i].x = current_x;
                    break;
                }
            }
        }
    }

    // 检查并重置不稳定方块的状态
    fn check_unstable_blocks(&mut self) {
        let block_count = self.blocks.len();
        let mut unstable = vec![false; block_count];

        // 检查每个已停止的方块是否有支撑
        for i in 0..block_count {
            if !self.blocks[i].is_stopped || self.blocks[i].is_merged {
                continue;
            }

            // 如果在地面上，就是稳定的
            if self.blocks[i].y >= self.game_height - self.blocks[i].size / 2.0 {
                continue;
            }

            // 检查是否有其他方块支撑
            let mut has_support = false;
            for j in 0..block_count {
                if i == j || self.blocks[j].is_merged {
                    continue;
                }

                let dx = self.blocks[j].x - self.blocks[i].x;
                let dy = self.blocks[j].y - self.blocks[i].y;
                
                // 判断是否有方块在正下方支撑
                if dy.abs() <= self.grid_size + 1.0 && dx.abs() < 1.0 && dy > 0.0 {
                    has_support = true;
                    break;
                }
            }

            // 如果没有支撑，标记为不稳定
            if !has_support {
                unstable[i] = true;
            }
        }

        // 重置不稳定方块的状态
        for i in 0..block_count {
            if unstable[i] {
                self.blocks[i].is_stopped = false;
                self.blocks[i].velocity_y = 0.0; // 重置速度，让它重新开始下落
            }
        }
    }
    
    // 绘制游戏画面
    fn draw(&self) {
        // 绘制分割线
        let (divider_screen_x, _) = self.world_to_screen(self.left_width, 0.0);
        let (_, divider_screen_y2) = self.world_to_screen(0.0, self.game_height);
        draw_line(divider_screen_x, 0.0, divider_screen_x, divider_screen_y2, 2.0, WHITE);
        
        // 绘制右边区域的网格背景
        self.draw_grid();
        
        // 将发射点坐标转换为屏幕坐标
        let (launch_screen_x, launch_screen_y) = self.world_to_screen(self.launch_x, self.launch_y);
        let launch_radius = 10.0 * self.scale_x.min(self.scale_y);
        
        // 绘制发射点（黄色圆圈）
        draw_circle(launch_screen_x, launch_screen_y, launch_radius, YELLOW);
        
        // 绘制所有方块
        for block in &self.blocks {
            block.draw(self.scale_x, self.scale_y, self.offset_x, self.offset_y);
        }
        
        // 绘制瞄准线 - 当按住鼠标左键时显示
        if is_mouse_button_down(MouseButton::Left) {
            let mouse_pos = mouse_position();
            draw_line(launch_screen_x, launch_screen_y, mouse_pos.0, mouse_pos.1, 2.0, WHITE);
        }

        // 绘制游戏说明文字
        let text_params = TextParams {
            font_size: 30,
            font: self.font.as_ref(),
            color: WHITE,
            ..Default::default()
        };
        
        let text_params_small = TextParams {
            font_size: 20,
            font: self.font.as_ref(),
            color: LIGHTGRAY,
            ..Default::default()
        };
        
        let text_params_yellow = TextParams {
            font_size: 20,
            font: self.font.as_ref(),
            color: YELLOW,
            ..Default::default()
        };
        
        let text_params_green = TextParams {
            font_size: 20,
            font: self.font.as_ref(),
            color: GREEN,
            ..Default::default()
        };

        draw_text_ex("点击鼠标左键发射方块！", 10.0, 30.0, text_params);

        // 绘制所有小字说明
        let descriptions = [
            ("方块会从左下角抛物线飞出", 60.0),
            ("按住鼠标左键可显示瞄准线", 85.0),
            ("左边：方块掉出屏幕会消失", 110.0),
            ("右边：方块会自动对齐网格", 135.0),
            ("相同数字的方块相邻会合成", 160.0),
            ("最大数字为64，不能继续合成", 185.0),
        ];

        for (text, y) in descriptions.iter() {
            draw_text_ex(text, 10.0, *y, text_params_small.clone());
        }
        
        // 显示方块数量
        let block_count = self.blocks.len();
        draw_text_ex(
            &format!("当前方块数量: {}", block_count),
            10.0,
            210.0,
            text_params_yellow
        );
        
        // 显示停止方块数量
        let stopped_count = self.blocks.iter().filter(|b| b.is_stopped).count();
        draw_text_ex(
            &format!("已停止方块数量: {}", stopped_count),
            10.0,
            235.0,
            text_params_green
        );

        // 显示游戏分数（使用更大更醒目的字体）
        let score_params = TextParams {
            font_size: 40,
            font: self.font.as_ref(),
            color: Color::from_rgba(255, 215, 0, 255), // 金色
            ..Default::default()
        };
        draw_text_ex(
            &format!("分数: {}", self.score),
            10.0,
            300.0,
            score_params
        );
    }
    
    // 绘制网格背景
    fn draw_grid(&self) {
        let grid_color = Color::from_rgba(150, 150, 150, 150); // 更明显的网格颜色
        let gap = 2.0; // 网格间隙
        
        // 绘制右边区域的网格
        for col in 0..=self.grid_cols {
            let x = self.left_width + col as f32 * self.grid_size;
            let (screen_x1, screen_y1) = self.world_to_screen(x, 0.0);
            let (screen_x2, screen_y2) = self.world_to_screen(x, self.game_height);
            draw_line(screen_x1, screen_y1, screen_x2, screen_y2, 1.0, grid_color);
        }
        
        for row in 0..=self.grid_rows {
            let y = row as f32 * self.grid_size;
            let (screen_x1, screen_y1) = self.world_to_screen(self.left_width, y);
            let (screen_x2, screen_y2) = self.world_to_screen(self.game_width, y);
            draw_line(screen_x1, screen_y1, screen_x2, screen_y2, 1.0, grid_color);
        }
        
        // 绘制网格单元格背景（带间隙）
        for col in 0..self.grid_cols {
            for row in 0..self.grid_rows {
                let x = self.left_width + col as f32 * self.grid_size + gap / 2.0;
                let y = row as f32 * self.grid_size + gap / 2.0;
                let (screen_x, screen_y) = self.world_to_screen(x, y);
                let (screen_w, screen_h) = self.world_to_screen(self.grid_size - gap, self.grid_size - gap);
                
                draw_rectangle(screen_x, screen_y, screen_w, screen_h, Color::from_rgba(50, 50, 50, 50));
            }
        }
    }
}

// 主函数 - 游戏入口点
#[macroquad::main("Turn Block Game")]
async fn main() {
    // 创建游戏状态实例
    let mut game_state = GameState::new().await;
    
    // 游戏主循环
    loop {
        // 处理用户输入 - 检测鼠标左键点击
        if is_mouse_button_pressed(MouseButton::Left) {
            game_state.spawn_block();  // 生成新方块
        }

        // 检测键盘输入
        if is_key_pressed(KeyCode::A) {
            game_state.try_move_blocks(-1);  // 向左移动
        }
        if is_key_pressed(KeyCode::D) {
            game_state.try_move_blocks(1);   // 向右移动
        }
        
        // 更新游戏状态 - 传入帧时间用于物理计算
        game_state.update(get_frame_time());
        
        // 清屏 - 设置黑色背景，确保渲染稳定
        clear_background(BLACK);
        
        // 绘制游戏画面
        game_state.draw();
        
        // 等待下一帧
        next_frame().await
    }
}
