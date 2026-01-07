
# Saving private keys

- For development, ok to use `.env` file
- Best to use keystore
  ```bash
  # save key to cast
  cast wallet import defaultKey --interactive

  # get key from cast
  cast wallet decrypt-keystore defaultKey

  # deploying with forge
  forge script script/DeploySimpleStorage.s.sol:DeploySimpleStorage --rpc-url $RPC_URL --account defaultKey --sender $PK_ADDR --broadcast -vvvv
  ```