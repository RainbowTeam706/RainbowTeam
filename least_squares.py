import numpy as np
import matplotlib.pyplot as plt

# 内置数据点
x = np.array([1, 2, 3, 4, 5])
y = np.array([2, 4, 5, 4, 5])
//添加一行注释测试分支上传合并是否可行
// 123456  nian commit
// 测试分支合并
# 最小二乘法拟合 y = a*x + b
A = np.vstack([x, np.ones(len(x))]).T
# 解法：最小二乘
solution = np.linalg.lstsq(A, y, rcond=None)
a, b = solution[0]

print(f"拟合直线: y = {a:.2f}x + {b:.2f}")

# 可视化
plt.scatter(x, y, color='red', label='数据点')
plt.plot(x, a*x + b, color='blue', label='拟合直线')
plt.xlabel('x')
plt.ylabel('y')
plt.legend()
plt.title('最小二乘法拟合')
plt.show() 
