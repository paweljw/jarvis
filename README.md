# jarvis

> "Sir, there are still terabytes of calculations required before an actual flight is..."
> "J.A.R.V.I.S., sometimes you gotta run before you can walk."
>
> ― J.A.R.V.I.S. and Tony Stark

Jarvis is designed to be the control node of a smart home appliance set. It does climate, light and media control. It's backend is designed to run fully within docker so failures don't take the entire node down. It takes advantage of GPUs for media-related tasks.

Currently Jarvis runs on a scavenged commodity-hardware frankenputer dubbed Adloquium.

## Setup

* Install ansible
* `bin/provision`
