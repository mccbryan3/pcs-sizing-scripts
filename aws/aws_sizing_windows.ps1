$awsregions = (aws ec2 describe-regions | ConvertFrom-Json).Regions.RegionName
$a = "Total regions: $($awsregions.Length)"
$msg += $a + "`n`n"
$a

$ec2_instance_count=0
$rds_instance_count=0
$elb_count=0
$redshift_count=0
$natgw_count=0

foreach ($i in $awsregions) {
    $count = ((aws ec2 describe-instances --max-items 100000 --region=$i --filters  "Name=instance-state-name,Values=running"  --output json | convertfrom-json).reservations).count
    $a = "Region=$i EC2 instance(s) in running state = $count"
    $msg += $a + "`n"
    $a
    $ec2_instance_count=$ec2_instance_count + $count
}

""
$a = "Total count of ec2 instances across all regions: $ec2_instance_count"
$msg += "`n" + $a + "`n`n"
$a
""

foreach ($i in $awsregions) {
    $count = ((aws rds describe-db-instances --region=$i --output json  | convertfrom-json).DBInstances).count
    $a = "Region=$i RDS instance(s) = $count"
    $msg += $a + "`n"
    $a
    $rds_instance_count=$rds_instance_count + $count
}

""
$a = "Total count of RDS instances across all regions: $rds_instance_count"
$msg += "`n" + $a + "`n`n"
$a
""

foreach ($i in $awsregions) {
    $count = $((aws elb describe-load-balancers --region=$i --output json  | convertfrom-json).LoadBalancerDescriptions).Count
    $a = "Region=$i ELBs= $count"
    $msg += $a + "`n"
    $a
    $elb_count=$elb_count + $count
}

""
$a = "Total count of ELBs across all regions: $elb_count"
$msg += "`n" + $a + "`n`n"
$a
""

foreach ($i in $awsregions) {
    $count = $((aws ec2 describe-nat-gateways --region=$i --output json).NatGateways).Count
    $a = "Region=$i NAT Gateway instances = $count"
    $msg += $a + "`n"
    $a
    $natgw_count=$natgw_count + $count
}

""
$a = "Total count of NAT gateways across all regions: $natgw_count"
$msg += "`n" + $a + "`n`n"
$a
""

foreach ($i in $awsregions) {
    $count = $((aws redshift describe-clusters --region=$i --output json).Clusters).Count
    $a = "Region=$i Redshift instances = $count"
        $msg += $a + "`n"
    $a
    $redshift_count=$redshift_count + $count
}

$msg += "`n"
$msg += "`n"
$msg += "Total count of Redshift clusters across all regions: $redshift_count`n"
$msg += "Total count of ec2 instances across all regions: $ec2_instance_count`n"
$msg += "Total count of RDS instances across all regions: $rds_instance_count`n"
$msg += "Total count of ELB (Classic) instances across all regions: $elb_count`n"
$msg += "Total count of Redshift clusters across all regions: $redshift_count`n"
$msg += "Total count of NAT gateways across all regions: $natgw_count`n"
$msg += "`n"
$msg += "Total billable resources: $($ec2_instance_count+$rds_instance_count+$elb_count+$redshift_count+$natgw_count)`n"
$msg += "Total billable with IAM module enabled: $(($ec2_instance_count+$rds_instance_count+$elb_count+$redshift_count+$natgw_count)*1.25)`n"

$msg
$msg | Out-File "PC-Sizing-AWS-Output-$((Get-Date).ToShortDateString().Replace("/","-")).txt"
