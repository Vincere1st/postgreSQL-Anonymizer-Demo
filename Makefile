.PHONY: init watch

init:
	docker compose up -d
	docker compose run --rm api npm install
	docker compose run --rm slidev npm install

watch:
	docker compose up -d --remove-orphans && \
	docker compose run --rm api npm run dev &
	docker compose run --rm slidev npm run dev