export TEKTON_DEMO_NS=tekton-pipelines
export TEKTON_DEMO_SA=tekton-dashboard


RELEASES=https://storage.googleapis.com/tekton-releases
TEKTON=$RELEASES/latest/release.yaml
DASH=$RELEASES/dashboard/latest/release.yaml

YAML=$(mktemp)
curl -s $TEKTON | \
     sed "s/tekton-pipelines/$TEKTON_DEMO_NS/g" | \
     sed "s/tekton-dashboard/$TEKTON_DEMO_SA/g" > $YAML
kubectl apply -f $YAML -n $TEKTON_DEMO_NS

curl -s $DASH | \
     sed "s/tekton-pipelines/$TEKTON_DEMO_NS/g" | \
     sed "s/tekton-dashboard/$TEKTON_DEMO_SA/g" > $YAML
kubectl apply -f $YAML -n $TEKTON_DEMO_NS


curl -s -m 2 localhost:9097 > /dev/null
if [ $? -eq 0 ] ; then
    echo connect to http://localhost:9097 for tekton dashboard
else 
    echo Running dashboard via port forward in Background
    echo See port-forward-tekton.log for port forwarding information
    
    sh port-forward-tekton  > port-forward-tekton.log &
fi 

kubectl apply -f pipelines -n $TEKTON_DEMO_NS

echo "Tekton Hack Installed "
