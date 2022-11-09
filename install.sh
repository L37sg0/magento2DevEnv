#!/bin/bash

# Remove previous magento
echo "Removing previous magento..."
rm -rf magento
echo "magento folder removed!"

# Pull magento release
echo "creating magento project..."
docker-compose exec app composer create-project \
--repository-url=https://repo.magento.com/ \
magento/project-community-edition \
magento
echo "magento created!"

#Install magento
echo "installing magento..."
docker-compose exec app magento/bin/magento setup:install \
--base-url=http://localhost \
--db-host=db \
--db-name=magento \
--db-user=magento \
--db-password=jJk84c@xdb2nCbgN \
--backend-frontname=admin \
--admin-firstname=admin \
--admin-lastname=admin \
--admin-email=admin@admin.com \
--admin-user=admin \
--admin-password=admin123 \
--language=en_US \
--currency=USD \
--timezone=America/Chicago \
--use-rewrites=1 \
--search-engine=elasticsearch7 \
--elasticsearch-host=es01 \
--elasticsearch-port=9200 \
--elasticsearch-index-prefix=magento \
--elasticsearch-timeout=15
docker-compose exec app magento/bin/magento setup:di:compile
echo "magento installation completed!"

# Switch to developer mode
echo "switching to developer mode..."
docker-compose exec app magento/bin/magento deploy:mode:set developer

# Install sample data
echo "installing sample data..."
docker-compose exec app magento/bin/magento sampledata:deploy
docker-compose exec app magento/bin/magento setup:upgrade
echo "sample data installed!"

# Disable 2FA and flush cache
echo "disabling 2FA..."
docker-compose exec app magento/bin/magento module:disable Magento_TwoFactorAuth
echo "2FA disabled!"
echo "flushing cache..."
docker-compose exec app magento/bin/magento cache:flush
echo "cache flushed!"