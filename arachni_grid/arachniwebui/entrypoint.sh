#!/bin/bash
/arachni/bin/arachni_web -o 0.0.0.0 > /tmp/arachniwebui.log&
sleep 3
/arachni/bin/arachni_web_script "Dispatcher.create(address:\"dispatcher\",port:7331,global:true,alive:true,description:\"dispatcher_grid\",user_ids:[1]).save(validate:false)"
tailf /tmp/arachniwebui.log

