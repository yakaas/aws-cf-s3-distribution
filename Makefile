
provision: build
	terraform apply  

build: clean

clean:

show: 
	terraform show 

plan: 
	terraform plan 

update: build
	terraform destroy 
	terraform apply 

.PHONY: provision build clean update destroy plan show