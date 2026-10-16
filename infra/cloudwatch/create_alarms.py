"""Create or update the CloudWatch alarms in alarms.json (ARCHITECTURE §13, PHASES 9.5).

Run once per environment from a machine with the AWS CLI signed in to the WellWish account:

    python infra/cloudwatch/create_alarms.py --env production --namespace WellWish/production \
        --alb app/wellwish-prod/123abc --target-group targetgroup/wellwish-api/456def \
        --topic-arn arn:aws:sns:ap-south-1:111122223333:wellwish-alerts

`--dry-run` prints the alarms instead of creating them. Running it again updates them.
"""

import argparse
import json
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).parent


def alarms(values: dict[str, str]) -> list[dict]:
    text = (HERE / "alarms.json").read_text(encoding="utf-8")
    for key, value in values.items():
        text = text.replace("${" + key + "}", value)
    if "${" in text:
        sys.exit("A ${...} value is missing: " + text[text.index("${") :][:40])
    return json.loads(text)["alarms"]


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--env", required=True, choices=["production", "staging"])
    parser.add_argument("--namespace", required=True, help="The backend's CLOUDWATCH_NAMESPACE")
    parser.add_argument("--alb", required=True, help="LoadBalancer dimension, app/...")
    parser.add_argument("--target-group", required=True, help="TargetGroup dimension")
    parser.add_argument("--topic-arn", required=True, help="SNS topic that tells the team")
    parser.add_argument("--region", default="ap-south-1")
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()
    found = alarms(
        {
            "ENV": args.env,
            "NAMESPACE": args.namespace,
            "ALB": args.alb,
            "TARGET_GROUP": args.target_group,
            "TOPIC_ARN": args.topic_arn,
        }
    )
    for alarm in found:
        alarm |= {"AlarmActions": [args.topic_arn], "OKActions": [args.topic_arn]}
        if args.dry_run:
            print(json.dumps(alarm, indent=2))
            continue
        subprocess.run(
            [
                "aws", "cloudwatch", "put-metric-alarm",
                "--region", args.region,
                "--cli-input-json", json.dumps(alarm),
            ],
            check=True,
        )  # fmt: skip
        print("set", alarm["AlarmName"])


if __name__ == "__main__":
    main()
