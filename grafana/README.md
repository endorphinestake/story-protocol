# Grafana Dashboard

![grafana screen](https://github.com/user-attachments/assets/43337e52-69ed-418f-9436-62ceca3d423f)

## Our monitoring is add-on to Grafana Dashboard by [Cumulo](https://github.com/Cumulo-pro/Story_protocol/blob/main/monitoring)

Our team made these modifications:

### Block Size (updated)
  
*cometbft_consensus_block_size_bytes*  

Indicates the amount of data contained in the last block, in bytes.

![Знімок екрана 2024-10-19 о 00 37 49](https://github.com/user-attachments/assets/9e880cf1-9e5c-49da-a2cc-4786270929ad)

### Consensus block interval (added)

*cometbft_consensus_block_interval_seconds_sum*

Total time between this and the last block.

![Знімок екрана 2024-10-19 о 00 39 17](https://github.com/user-attachments/assets/e9cd8552-059a-46f6-8cb4-fb5211049572)

### Latest block height (updated)

changed *cometbft_block_latest_block_height* to *cometbft_consensus_latest_block_height*

This is the number of the highest block processed by the node, indicating whether it is up to date with the network.

![Знімок екрана 2024-10-19 о 00 41 06](https://github.com/user-attachments/assets/2d946c9e-4fe9-4833-b8d9-e2c4723cb6cd)

### Validator power (added)
*cometbft_consensus_validators_power*
Total power of all validators.

![Знімок екрана 2024-10-19 о 00 45 47](https://github.com/user-attachments/assets/f37dd1d7-8a17-4c3a-a433-c08247b096a3)


### Number of validators (added)
*cometbft_consensus_validators*

![Знімок екрана 2024-10-19 о 00 43 55](https://github.com/user-attachments/assets/7f92372a-61c9-4b2f-bd53-69f93cefc97f)


### Vote extension receive count (added)
*cometbft_consensus_vote_extension_receive_count*

VoteExtensionReceiveCount is the number of vote extensions received by this node. The metric is annotated by the status of the vote extension from the application, either 'accepted'  or 'rejected'.

![Знімок екрана 2024-10-19 о 00 44 40](https://github.com/user-attachments/assets/98e654ec-06db-4f92-bfe1-96abd4a0e137)

### Mempool active outbound connections (added)
*cometbft_mempool_active_outbound_connections*

Number of connections being actively used for gossiping transactions (experimental feature).

![Знімок екрана 2024-10-19 о 00 49 21](https://github.com/user-attachments/assets/cca38ae6-03ee-4b59-bbb9-a5e4c7fac71c)


### P2P sent bytes (added)
*cometbft_p2p_peer_send_bytes_total*

Number of bytes sent to a given peer.

![Знімок екрана 2024-10-19 о 00 49 37](https://github.com/user-attachments/assets/38d6ecb3-64a3-4ffd-8e5d-8dd0be223614)

### P2P received bytes (added)
*cometbft_p2p_peer_receive_bytes_total*

Number of bytes received from a given peer.

![Знімок екрана 2024-10-19 о 00 52 18](https://github.com/user-attachments/assets/9796a037-99e5-4071-bc1d-77a98e4bfc82)

### P2P pending (added)
*cometbft_p2p_peer_pending_send_bytes*

Pending bytes to be sent to a given peer.

![Знімок екрана 2024-10-19 о 00 52 30](https://github.com/user-attachments/assets/3a59c54b-3787-493d-a04a-d995fb1069b7)

### Consensus Parameters (added)
*cometbft_consensus_step_duration_seconds*

Added “Consensus Steps” - Histogram of durations for each step in the consensus protocol.

![Знімок екрана 2024-10-19 о 00 54 04](https://github.com/user-attachments/assets/77707c10-3917-492a-b6d1-48aab08695a9)

### Round voting power (added)

*cometbft_consensus_round_voting_power_percent*

RoundVotingPowerPercent is the percentage of the total voting power received with a round. The value begins at 0 for each round and approaches 1.0 as additional voting power is observed. The metric is labeled by vote type.

![Знімок екрана 2024-10-19 о 00 55 57](https://github.com/user-attachments/assets/2df7401f-336f-42cf-bbf9-ee9968b77377)


### Quorum prevote delay (added)

*cometbft_consensus_quorum_prevote_delay*

Interval in seconds between the proposal timestamp and the timestamp of the earliest prevote that achieved a quorum.

![Знімок екрана 2024-10-19 о 00 56 10](https://github.com/user-attachments/assets/f615599a-6a51-4249-a536-58bc7ae55af7)


### Round duration (added)
*cometbft_consensus_round_duration_seconds_sum*

Histogram of round duration.

![Знімок екрана 2024-10-19 о 00 58 56](https://github.com/user-attachments/assets/0b1ddeca-4b37-435c-ac6a-dee034a7652c)


### Number of rounds (added)
*cometbft_consensus_rounds*

![Знімок екрана 2024-10-19 о 00 59 08](https://github.com/user-attachments/assets/a9460c8d-b870-4a14-b23f-5718c2fd0fb3)


### Block gossip parts (added)

*cometbft_consensus_block_gossip_parts_received*

Number of block parts received by the node, separated by whether the part was relevant to the block the node is trying to gather or not.

![Знімок екрана 2024-10-19 о 00 59 34](https://github.com/user-attachments/assets/aa23718a-759d-4d9c-9bcb-56201401d1e1)


### Consensus block parts (added)

*cometbft_consensus_block_parts*

Number of block parts transmitted by each peer.

![Знімок екрана 2024-10-19 о 00 59 49](https://github.com/user-attachments/assets/001c7daa-32e5-43dc-9ab7-f74cbc41e267)














