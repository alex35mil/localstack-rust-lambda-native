Run LocalStack:

```sh
LAMBDA_IGNORE_ARCHITECTURE=1 localstack start
```

Build and deploy the Lambda function:

```sh
./deploy.sh
```

> In essence, this script runs `cargo build --release` and then deploys to LocalStack with Terraform by running `terraform apply -auto-approve`.

The script would print the function URL.

Once invoked, LocalStack returns a timeout error:

```
2024-08-07T11:53:06.414  WARN --- [   Thread-96] l.s.l.i.execution_environm : Execution environment a869565f079d4bfe5c153e7471bec8ab for function arn:aws:lambda:us-west-2:000000000000:function:hello-world-fn:$LATEST timed out during startup. Check for errors during the startup of your Lambda function and consider increasing the startup timeout via LAMBDA_RUNTIME_ENVIRONMENT_TIMEOUT.
2024-08-07T11:53:06.487 ERROR --- [   asgi_gw_1] l.aws.handlers.logging     : exception during call chain: Execution environment timed out during startup.
2024-08-07T11:53:06.487  INFO --- [   asgi_gw_1] localstack.request.http    : GET / => 500
```
