use std::io;

use lambda_http::{
    run, service_fn,
    tracing::{self, subscriber::EnvFilter},
    Body, Error as LambdaError, Request, Response,
};

#[tokio::main]
async fn main() -> Result<(), LambdaError> {
    tracing::subscriber::fmt()
        .with_env_filter(EnvFilter::from_default_env())
        .with_writer(io::stdout)
        .with_file(true)
        .with_line_number(true)
        .init();

    run(service_fn(function_handler)).await
}

async fn function_handler(_event: Request) -> Result<Response<Body>, LambdaError> {
    let res = Response::builder()
        .status(200)
        .header("content-type", "text/html")
        .body("Hello from LocalStack".into())
        .map_err(Box::new)?;

    Ok(res)
}
