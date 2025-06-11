### etcd 单机版

```shell
# 当前目录下所有文件赋予权限(读、写、执行)
chmod -R 777 ./etcd
# 运行 -- 单机模式
docker-compose -f docker-compose-etcd.yml -p etcd up -d
```

###### 访问etcd

```shell
# 使用etcdctl客户端
docker exec -it etcd etcdctl put key1 value1
docker exec -it etcd etcdctl get key1

# 通过HTTP API
curl -L http://localhost:2379/v2/keys/key1
```

###### 访问etcd-keeper可视化界面

浏览器访问：http://localhost:8080
连接地址填写：http://etcd:2379
``` 