.PHONY:
merge-pullrequest:
	ifndef MERGE_USER
	$(error MERGE_USER is not set)
	endif
	BRANCH=`git rev-parse --abbrev-ref HEAD`
	git checkout -b $(MERGE_USER)-$(BRANCH) $(BRANCH) && \
	git pull git@github.com:$(MERGE_USER)/$(NAME) $(BRANCH) && \
	git checkout $(BRANCH) && \
	git merge --no-ff $(MERGE_USER)-$(BRANCH)