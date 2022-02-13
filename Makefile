K8S_VERSION = v1.23.3

ifndef $(GOPATH)
  export GOPATH=${HOME}/go
  ${shell mkdir -p ${GOPATH}}
endif

ifndef $(GOBIN)
  export GOBIN=${GOPATH}/bin
endif

.PHONY: cluster
cluster:
	kind create cluster --config ./kindconfig.yaml
	kubectl create namespace flux-system
	kubectl create namespace infra
	gpg --export-secret-keys --armor "9DC11809DD7D102342B09932C40921F65EFEF866" | kubectl create secret generic sops-gpg --namespace=flux-system --from-file=sops.asc=/dev/stdin
	gpg --export-secret-keys --armor "9DC11809DD7D102342B09932C40921F65EFEF866" | kubectl create secret generic sops-gpg --namespace=infra --from-file=sops.asc=/dev/stdin
	
.PHONY: v1.23
v1.23:
	mkdir -p ${GOPATH}
	git clone https://github.com/kubernetes/kubernetes.git ${GOPATH}/src/k8s.io/kubernetes || true
	cd ${GOPATH}/src/k8s.io/kubernetes && git checkout v1.23.3 || git pull
	go get sigs.k8s.io/kind
	export PATH=${HOME}/bin:${PATH}
	kind build node-image --image=master

.PHONY: destroy
destroy:
	kind delete cluster --name subject86
