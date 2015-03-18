run:
	node coffee_bridge.js

unit:
	./node_modules/mocha/bin/_mocha --compilers coffee:coffee-script/register ./test/unit

integration:
	./node_modules/mocha/bin/_mocha --compilers coffee:coffee-script/register ./test/integration

server:
	-rm nohup.out
	$(MAKE) kill-node
	(NODE_ENV=development nohup node coffee_bridge.js &)
	sleep 3
	./node_modules/mocha/bin/_mocha --compilers coffee:coffee-script/register ./test/server


test:
	$(MAKE) unit
	$(MAKE) integration

kill-node:
	-kill `ps -eo pid,comm | awk '$$2 == "node" { print $$1 }'`

.PHONY: test
