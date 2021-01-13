# Prisma Cloud AWS Sizing Scripts

## resource-count.sh ##

### Information

Script used to calculate sizing for AWS accounts from a __Linux__ machine using awscliv2.

## aws_sizing_windows.ps1 ##

__Tested on Windows 10 with Powershell 7.1.0 and AWSCLI v2__

### Information

Script used to calculate sizing for AWS accounts from a __Windows__ machine using powerhsell and awscliv2.

### Usage

1. Install [AWSCLIv2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-windows.html) on your Windows machine.
2. Verify operations by running 
   
   ```aws ec2 describe-instances```

3. Once the awscliv2 utility has been verified run the script.

    ```aws_sizing_windows.ps1```

4. Return output file located in the working directory to the Prisma Cloud team.