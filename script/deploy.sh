ssh -t root@hellespontus.com "cd oladium && \
git pull && \
touch tmp/restart.txt && \
exit"
echo "Succesfully deployed"
