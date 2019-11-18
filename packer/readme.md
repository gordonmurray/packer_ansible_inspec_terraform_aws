## Validate an image file

packer validate -var-file=../packer/variables.json ../packer/server.json

## Build the image

packer build -var-file=../packer/variables.json ../packer/server.json
