include .env
export

export PROJECT_ROOT := $(shell pwd)


env-up:
	@docker compose up -d app-postgres


env-down:
	@docker compose down app-postgres


env-cleanup:
	@read -p "Cleanup all volume env files? All data will be erased. [y/N]: " answer; \
	if [ "$$answer" = "y" ]; then \
		docker compose down app-postgres && \
		sudo rm -rf out/pgdata && \
		echo "Env data were cleared"; \
	else \
		echo "Env cleanup - was interrupted"; \
	fi;


migrate-create:
	@if [ -z "$(seq)" ]; then \
		echo "None seq parameter. Use: make migrate-create seq=init"; \
		exit 1; \
	fi; \

	@docker compose run --rm app-postgres-migrate \
		create \
		-ext sql \
		-dir /migrations \
		-seq "$(seq)"


migrate-action:
	@if [ -z "$(action)" ]; then \
		echo "None action parameter. Use: make migrate-action action=act_name"; \
		exit 1; \
	fi; \

	
	@docker compose run --rm app-postgres-migrate \
		-path /migrations \
		-database postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@app-postgres:5432/${POSTGRES_DB}?sslmode=disable \
		"$(action)"

	
migrate-up:
	@make migrate-action action=up


migrate-down:
	@make migrate-action action=down


env-port-forward:
	@docker compose up -d app-port-forwarder 


env-port-close:
	@docker compose down app-port-forwarder 