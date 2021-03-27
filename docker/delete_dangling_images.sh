docker rmi $(docker images -f "dangling=true" -q)
