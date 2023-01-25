# Virtual thread performance benchmark

## About The Project

The project objective is to allow executing repeatable performance tests in different technical stacks and validate the performance of applications based on virtual threads. This project is mainly designed to be executed on an AWS account, however the stacks scenarios are developed and designed to run in Docker

## Results

![Throughput](/reports/throughput.png)

See current results at our [Github Page](https://bancolombia.github.io/virtual-thread-performance-benchmark/)

## Getting Started

### Prerequisites

To run this project you need:

- `aws-cli` and an AWS account
- `jq` is a lightweight and flexible command-line JSON processor.[Download here](https://stedolan.github.io/jq/download/).

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/bancolombia/virtual-thread-performance-benchmark
   cd virtual-thread-performance-benchmark
   ```

2. Update your configuration in `config.json`   
   ```json
    {
        "StackName": "test-stack",                       # Prefix for test name
        "UrlReposity": "https://github.com/maocq/virtual-threads-benchmark-t",
        "VpcId": "vpc-0e4be5df9e95671aa",                # Your vcp
        "SubnetId": "subnet-01c7c6eb4150116c4",          # Your subnet
        "InstanceType": "c5.large",                      # AWS instance type
        "ImageId": "ami-0574da719dca65348",
        "User": "ubuntu",                                # Default user of the ami
        "KeyName": "johncarm-test",                      # Name of your key
        "Key": "/home/mao/mao/keys/johncarm-test.pem"    # Location of your key
    }
   ```

## Usage

```shell
./start_all.sh
```

The following are the tested scenarios

##### Case one

```mermaid
sequenceDiagram
    actor Client
    Client->>Application: 
    Application->>ExternalService: Request
    ExternalService->>ExternalService: Simulate latency
    ExternalService->>Application: Response
    Application->>Application: Cpu bound task
    Application->>Client: Response
```

##### Case two

```mermaid
sequenceDiagram
    actor Client
    Client->>Application: 
    Application->>ExternalService: Request
    ExternalService->>ExternalService: Simulate latency
    ExternalService->>Application: Response
    Application->>Client: Response
```

##### Case three

```mermaid
sequenceDiagram
    actor Client
    Client->>Application:     
    Application->>Application: Cpu bound task
    Application->>Client: Response
```

## License

Distributed under the MIT License. See `LICENSE` for more information.