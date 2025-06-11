### etcd 集群版

```shell
# 当前目录下所有文件赋予权限(读、写、执行)
chmod -R 777 ./etcd-cluster
# 运行 -- 集群模式
docker-compose -f docker-compose-etcd-cluster.yml -p etcd-cluster up -d
```

###### 访问etcd集群

```shell
# 使用etcdctl客户端 (可以通过任意节点操作)
docker exec -it etcd1 etcdctl put key1 value1
docker exec -it etcd1 etcdctl get key1

# 查看集群成员
docker exec -it etcd1 etcdctl member list

# 通过HTTP API (可以访问任意节点)
curl -L http://localhost:12379/v2/keys/key1
curl -L http://localhost:22379/v2/keys/key1
curl -L http://localhost:32379/v2/keys/key1
```

###### 访问etcd-keeper可视化界面

浏览器访问：http://localhost:8081
连接地址可以填写集群中任意节点：
- http://etcd1:2379
- http://etcd2:2379
- http://etcd3:2379 