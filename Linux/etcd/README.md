# etcd

etcd 是一个分布式键值存储系统，用于配置共享和服务发现。

## 特性

- 简单：基于HTTP+JSON的API
- 安全：可选SSL客户端证书认证
- 快速：单实例每秒1000次写操作
- 可靠：使用Raft算法实现分布式一致性

## 版本

- 3.5.9
  - [单机版](./3.5.9/01-单机/run.md)
  - [集群版](./3.5.9/02-集群/run.md)

## 常用命令

```shell
# 写入数据
etcdctl put key value

# 读取数据
etcdctl get key

# 删除数据
etcdctl del key

# 监听数据变化
etcdctl watch key

# 查看集群成员
etcdctl member list
```

## 应用场景

- 服务发现
- 配置中心
- 分布式锁
- Leader选举

## 相关链接

- [etcd官方文档](https://etcd.io/docs/)
- [etcd GitHub](https://github.com/etcd-io/etcd)
- [etcdkeeper](https://github.com/evildecay/etcdkeeper) - etcd可视化管理工具 