# Freya
Lambda-esque server running in Docker


# Creating a lambda

You can create a lambda by sending a HTTP `POST` request to `<freyaURL>/create`, with the following data, encoded as form data:

### `file`

**Required** A NodeJS file containing the file to execute

### `name`

**Required** The name of the lambda

### `runFunction`

**Optional** The name of the `module.exports` to use.

For example, `module.exports.run` would have this set to `run`

## Example (curl):

```sh
curl -F "file=@code.js" -F "name=myLambda" -F "runFunction=exportedFunction"  http://localhost:4001/create
```

# Deleting a lambda

A lambda can be deleted by sending a HTTP `DELETE` request to `<freyaURL>/:lambdaName`

## Example (curl):

```sh
curl -X DELETE http://localhost:4001/myLambda
```

# Executing a lambda

A lambda can be executed by sending a HTTP `GET` to `<freyaURL>/:lambdaName`

## Example (curl):

```sh
curl http://localhost:4001/myLambda
```