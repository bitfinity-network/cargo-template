#[ic_cdk_macros::query]
fn greet(name: String) -> String {
    format!("Hello, {}! This is next upgrade", name)
}
