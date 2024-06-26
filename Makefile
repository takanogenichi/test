help: ## help表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

up: ## docker起動。
	docker-compose up -d
down: ## docker停止。(ディスクは残る)
	docker-compose down
downv: ## docker停止＆ディスククリア。
	docker-compose down -v
logd: ## docker-compose logsをtailf
	docker-compose logs -f
