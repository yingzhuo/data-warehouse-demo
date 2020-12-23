version := 0.0.1-$(shell /bin/date '+%Y%m%d%H%M%S')

usage:
	@echo "========================================================================================================"
	@echo "data-warehouse-demo"
	@echo "--------------------------------------------------------------------------------------------------------"
	@echo "usage         -> 显示菜单"
	@echo "build-jar     -> 构建Jar文件"
	@echo "build-image   -> 构建Docker镜像"
	@echo "push-image    -> 推送Docker镜像到Harbor服务器"
	@echo "clean         -> 清理构建产物"
	@echo "github        -> 推送代码到 \"https://github.com/yingzhuo/data-warehouse-demo\""
	@echo "========================================================================================================"

build-jar:
	@mvn -f $(CURDIR)/pom.xml clean package -D version=$(version)

build-image: build-jar
	@docker image build --tag 192.168.99.115/data-warehouse/business-sub-system:$(version) $(CURDIR)/01-business-sub-system/target/docker-context/
	@docker image tag 192.168.99.115/data-warehouse/business-sub-system:$(version) 192.168.99.115/data-warehouse/business-sub-system:latest

push-image: build-image
	@docker login --username=${HARBOR_USERNAME} --password=${HARBOR_PASSWORD} 192.168.99.115 &> /dev/null
	@docker image push 192.168.99.115/data-warehouse/business-sub-system:$(version)
	@docker image push 192.168.99.115/data-warehouse/business-sub-system:latest
	@docker logout 192.168.99.115 &> /dev/null

clean:
	@mvn -f $(CURDIR)/pom.xml clean -q
	@docker system prune -a -f &> /dev/null

github:
	@git add .
	@git commit -m "$(shell /bin/date "+%F %T")"
	@git push

.PHONY: usage build-jar build-image push-image clean github