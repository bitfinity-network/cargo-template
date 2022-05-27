#[ic_cdk_macros::query]
fn greet(name: String) -> String {
    format!("Hello, {}! This is upgrade v 22", name)
}
