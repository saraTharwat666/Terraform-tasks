# Terraform AWS Tasks

![Terraform](https://miro.medium.com/1*SZI5QIEZEYUUQuB4pQfTjw.gif)

## Overview

This repository contains Terraform tasks for practicing Infrastructure as Code (IaC) on AWS using real scenarios.

## Contents

* S3 static website hosting
* Terraform modules
* Variables and outputs
* Resource dependencies

## Project Example

### S3 Static Website

* Create S3 bucket
* Enable static website hosting
* Configure public access
* Upload `index.html`
* Output website URL

## Structure

```bash
.
├── main.tf
├── outputs.tf
├── index.html
└── modules/
    └── s3-static-site/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Usage

```bash
terraform init
terraform apply
```

## Output

```
http://aws:4566/nautilus-web-1034/index.html
```
