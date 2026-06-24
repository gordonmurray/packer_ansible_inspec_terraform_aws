## Validate the template

```sh
packer init .
packer validate .
```

## Build the image

```sh
packer build .
```

Run from this `packer/` directory. Credentials come from the standard AWS
chain (`AWS_PROFILE` or the usual environment variables).
