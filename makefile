FILE := $(word 2, $(MAKECMDGOALS))

run:
	@go run . run "${FILE}"

as:
	@go run . as "${FILE}"