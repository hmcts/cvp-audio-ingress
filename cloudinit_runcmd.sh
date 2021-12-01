# paramaters:
# certThumbprint certPassword numApplications
${certThumbprint} = $1
${certPassword} = $2
${numApplications} = $3

dpkg-query -l fuse && echo "Fuse already installed" || sudo apt-get install -y fuse
dpkg-query -l blobfuse && echo "Blobfuse already installed" || sudo apt-get install -y blobfuse
[[ -f "/wse-plugin-autorecord.zip" ]] && echo "wse-plugin-autorecord.zip aready downloaded" || wget https://www.wowza.com/downloads/forums/collection/wse-plugin-autorecord.zip && unzip wse-plugin-autorecord.zip && mv lib/wse-plugin-autorecord.jar /usr/local/WowzaStreamingEngine/lib/ && chown wowza: /usr/local/WowzaStreamingEngine/lib/wse-plugin-autorecord.jar
[ ! -d /mnt/blobfusetmp ] && sudo mkdir /mnt/blobfusetmp
[ ! -d /usr/local/WowzaStreamingEngine/content/azurecopy ] && sudo mkdir /usr/local/WowzaStreamingEngine/content/azurecopy
certDir="/var/lib/waagent/"
secretsname=$(find $certDir -name "${certThumbprint}.prv" | cut -c -57)
secretsPfx=$(find $certDir -name "${certThumbprint}.pfx")
[[ ! -z "$secretsPfx" ]] && echo "PFX exists" || openssl pkcs12 -export -out $secretsname.pfx -inkey $secretsname.prv -in $secretsname.crt -passin pass: -passout pass:${certPassword}
export PATH=$PATH:/usr/local/WowzaStreamingEngine/java/bin
keytool -importkeystore -srckeystore $secretsname.pfx -srcstoretype pkcs12 -destkeystore /usr/local/WowzaStreamingEngine/conf/ssl.wowza.jks -deststoretype JKS -deststorepass ${certPassword} -srcstorepass ${certPassword}
sudo bash /home/wowza/mount.sh /usr/local/WowzaStreamingEngine/content/azurecopy
/home/wowza/dir-creator.sh ${numApplications}
/home/wowza/log-mount.sh
sudo service WowzaStreamingEngine restart