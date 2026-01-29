.PHONY: format

format:
	pnpm dlx prettier --write README.md
	pnpm dlx prettier --write NOTES.md
