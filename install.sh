NS=$(oc project --short) 
kubectl apply -f tasks -n $NS
kubectl apply -f pipelines -n $NS