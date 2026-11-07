# SOC Investigation Report - Failed SSH Authentication

## 1. Event Summary

**Date:** November 7, 2026

**Event type:** Failed SSH authentication attempts

**Environment:** Isolated cybersecurity laboratory

**Monitored system:** Kali Linux

**Analysis tools:** Filebeat, Elasticsearch, Kibana

## 2. Detection

Four failed SSH authentication events were identified using Kibana Discover.

The following KQL query was used:

`message: "Failed password"`

## 3. Evidence

| Field | Value |
|---|---|
| Source IP | 127.0.0.1 |
| Target account | konrad |
| Host | kali |
| Failed attempts | 4 |
| First event | 11:35:15 |
| Last event | 11:35:41 |
| Authentication method | SSH password |

Example log:

`Failed password for konrad from 127.0.0.1 port 60742 ssh2`

## 4. Investigation

The events were reviewed in Kibana using timestamps and authentication messages.

All four failed attempts originated from the same loopback IP address and targeted the same account within approximately 27 seconds.

This activity resembles a small cluster of repeated authentication failures, a pattern that can be associated with SSH password guessing.

## 5. Assessment

**Classification:** Controlled authentication failure simulation

**Confirmed malicious activity:** No

The events were generated intentionally for testing. Four failed authentication attempts alone do not establish an actual brute-force attack.

## 6. Recommended SOC Actions

In a real SOC environment, an analyst should:

- Check whether the source IP belongs to an authorized user or system.
- Investigate surrounding authentication events, including successful logins.
- Identify additional affected accounts or hosts.
- Review the frequency and duration of failed attempts.
- Document findings and escalate according to the organization's incident response procedures when warranted.

## 7. Conclusion

The lab successfully demonstrated centralized SSH log collection, Kibana-based investigation, and basic SOC L1 event analysis.

No unauthorized access or confirmed security incident was identified.

