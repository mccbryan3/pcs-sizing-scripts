$awsregions = (aws ec2 describe-regions | ConvertFrom-Json).Regions.RegionName
"Total regions: $($awsregions.Length)"

$ec2_instance_count=0
$rds_instance_count=0
$elb_count=0
$redshift_count=0
$natgw_count=0

foreach ($i in $awsregions) {
    $count = ((aws ec2 describe-instances --max-items 100000 --region=$i --filters  "Name=instance-state-name,Values=running"  --output json | convertfrom-json).reservations).count
    "Region=$i EC2 instance(s) in running state = $count"
    $ec2_instance_count=$ec2_instance_count + $count
}

""
"Total count of ec2 instances across all regions: $ec2_instance_count"
""

foreach ($i in $awsregions) {
    $count = ((aws rds describe-db-instances --region=$i --output json  | convertfrom-json).DBInstances).count
    "Region=$i RDS instance(s) = $count"
    $rds_instance_count=$rds_instance_count + $count
}

""
"Total count of RDS instances across all regions: $rds_instance_count"
""

foreach ($i in $awsregions) {
    $count = $((aws elb describe-load-balancers --region=$i --output json  | convertfrom-json).LoadBalancerDescriptions).Count
    "Region=$i ELBs= $count"
    $elb_count=$elb_count + $count
}

""
"Total count of ELBs across all regions: $elb_count"
""

foreach ($i in $awsregions) {
    $count = $((aws ec2 describe-nat-gateways --region=$i --output json).NatGateways).Count
    "Region=$i NAT Gateway instances = $count"
    $natgw_count=$natgw_count + $count
}

""
"Total count of NAT gateways across all regions: $natgw_count"
""

foreach ($i in $awsregions) {
    $count = $((aws redshift describe-clusters --region=$i --output json).Clusters).Count
    "Region=$i Redshift instances = $count"
    $redshift_count=$redshift_count + $count
}

""
"Total count of Redshift clusters across all regions: $redshift_count"
""
""
"Total count of ec2 instances across all regions: $ec2_instance_count"
"Total count of RDS instances across all regions: $rds_instance_count"
"Total count of ELB (Classic) instances across all regions: $elb_count"
"Total count of Redshift clusters across all regions: $redshift_count"
"Total count of NAT gateways across all regions: $natgw_count"
"Total billable resources: $($ec2_instance_count+$rds_instance_count+$elb_count+$redshift_count+$natgw_count)"