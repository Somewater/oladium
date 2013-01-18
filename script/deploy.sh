ssh -t root@hellespontus.com "cd oladium && \
git pull && \
thin -C /etc/thin/oladium.yml restart && \
exit"
echo "Succesfully deployed"
