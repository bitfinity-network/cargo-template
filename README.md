# InfinitySwap example project

The main goal of this project is to show and test CI capabilities and also to provide you with some overall view about projects structure.

This project is using reusable templates from the [ci-wf](https://github.com/orgs/infinity-swap/ci-wf).

## Testing
To run tests we use debian based image from the [ci-tools](https://github.com/orgs/infinity-swap/ci-tools) with dfx installed and all NNS modules. It would allow you to run integration tests by staring DFX based on configuration in `~/dfx.json` .

If you have only unit tests than you just run `cargo test` as usual without configuring any DFX environment.


## Publishing
This project could publish ANY files wrapped inside a docker image to the [Github Packages](https://github.com/orgs/infinity-swap/packages).

This is a cool workaround to bypass Github limits for published package types. Thus you are able to publish wrapped wasm modules and use them later in another pipelines.


## Tagging

CI workspace has additional action that tags main branch on each commit to the main by increasing minor release.
Such capability could be useful if you kinda lazy to tag everything manually :)

## DFX auto generated readme

Welcome to your new hello_ic project and to the internet computer development community. By default, creating a new project adds this README and some template files to your project directory. You can edit these template files to customize your project and to include your own code to speed up the development cycle.

To get started, you might want to explore the project directory structure and the default configuration file. Working with this project in your development environment will not affect any production deployment or identity tokens.

To learn more before you start working with hello_ic, see the following documentation available online:

- [Quick Start](https://smartcontracts.org/docs/quickstart/quickstart-intro.html)
- [SDK Developer Tools](https://smartcontracts.org/docs/developers-guide/sdk-guide.html)
- [Rust Canister Devlopment Guide](https://smartcontracts.org/docs/rust-guide/rust-intro.html)
- [ic-cdk](https://docs.rs/ic-cdk)
- [ic-cdk-macros](https://docs.rs/ic-cdk-macros)
- [Candid Introduction](https://smartcontracts.org/docs/candid-guide/candid-intro.html)
- [JavaScript API Reference](https://erxue-5aaaa-aaaab-qaagq-cai.raw.ic0.app)

If you want to start working on your project right away, you might want to try the following commands:

```bash
cd hello_ic/
dfx help
dfx config --help
```

## Running the project locally

If you want to test your project locally, you can use the following commands:

```bash
# Starts the replica, running in the background
dfx start --background

# Deploys your canisters to the replica and generates your candid interface
dfx deploy
```

Once the job completes, your application will be available at `http://localhost:8000?canisterId={asset_canister_id}`.
