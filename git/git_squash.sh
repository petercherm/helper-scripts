#!/bin/zsh

YELLOW='\033[1;33m'
NC='\033[0m' # No Color

if [ ! $1 ]; then
	echo "${YELLOW}Please enter the squashed commit message:${NC}"
	read COMMIT_MESSAGE
else
	COMMIT_MESSAGE=$1
fi

CURRENT_BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

# Make sure we don't make a backup branch repeatedly
if [[ $CURRENT_BRANCH_NAME == backup* ]]; then
	echo >&2 "${YELLOW}Branch '"$CURRENT_BRANCH_NAME"' is already a backup${NC}"
	exit 1
fi

BACKUP_BRANCH_NAME="backup/$(date +%Y-%m-%d/%H-%M-%S)/$CURRENT_BRANCH_NAME"
git branch $BACKUP_BRANCH_NAME

git reset --soft HEAD~$(git rev-list --count HEAD ^master)
git add .
git commit -m "$COMMIT_MESSAGE"
