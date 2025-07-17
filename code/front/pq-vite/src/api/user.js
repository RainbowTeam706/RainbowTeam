// �����װ��axios���󹤾�
import request from '../utils/request'

// ��¼API�����������û�����������Ϊ����
export function login(username, password) {
  // ����POST���󵽺�˵�¼�ӿڣ������û���������
  console.log(username,password)
  return request.post('/user/login', {
    username, // �û���
    password  // ����
  })
}

// ע��API�����������û�����������Ϊ����
export function register(username, password) {
  // ����POST���󵽺��ע��ӿڣ������û���������
  return request.post('/user/register', {
    username, // �û���
    password  // ����
  })
}

// ��ȡ��ǰ�û���Ϣ
export function getUserInfo() {
  return request.get('/user/me')
}
