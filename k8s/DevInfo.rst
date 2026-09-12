
.kube configured in tin@m02
per info provided by Bk k8s https://berkelium.scs.lbl.gov/portal/access/?ns=sn


# 4. Test access (authenticates via Authentik browser window)
kubectl get pods -n sn




**^ tin bigmac2 ~/.kube ^**> kubectl config current-context
oidc@berkelium
**^ tin bigmac2 ~/.kube ^**> kubectl get pods -A | grep sn
coder                     coder-httpcilogonorgserverausers180116-sn-openclaw                1/1     Running            0               9d
sn                        psg-site-775c7857f9-gq2w9                                         0/1     CrashLoopBackOff   6 (4m50s ago)   11m
sn                        psg-site-775c7857f9-njrxf                                         0/1     Running            7 (5m10s ago)   11m
**^ tin bigmac2 ~/.kube ^**> 




  314  less deployment.yaml 
  315  kubectl config current-context
  316  kubectl get ns
  317  ls
  318  less kustomization.yaml 
  319  less service.yaml 
  320  less ingress.yaml 
  321  less deployment.yaml 
  322  kubectl -n sn apply -k /Users/tin/tin-git/psg/k8s
  323  kubectl -n sn get deploy,pods,svc,ingress
  324  kubectl -n sn get deploy,pods,svc,ingress
  325  kubectl -n sn logs deploy/psg-site
  326  host: psg.example.com
  327  kubectl -n sn get svc psg-site
  328  git status



# rebuild container using Docker.web (renamed) created by Copilot

docker build -f Dockerfile.web -t ghcr.io/tin6150/psg:master .
docker push ghcr.io/tin6150/psg:master


2) Restart the pod in namespace sn
kubectl -n sn rollout restart deployment/psg-site
kubectl -n sn rollout status deployment/psg-site
# ^^ quickest way to deploy, but still lots of waiting...
That is the cleanest way to pick up the new image.


3) If you want to force the exact image assignment
kubectl -n sn set image deployment/psg-site psg-site=ghcr.io/tin6150/psg:master
kubectl -n sn rollout status deployment/psg-site

4) Check the new pods
kubectl -n sn get pods -l app=psg-site -o wide
kubectl -n sn logs deployment/psg-site

# check status
kubectl -n sn get deploy,pods,svc,ingress


delete and restart
kubectl -n sn delete deployment,service,ingress psg-site --ignore-not-found
kubectl -n sn apply -k /Users/tin/tin-git/psg/k8s


clean up ingress:
kubectl -n sn delete service psg-site
kubectl -n sn delete ingress psg-site



"pause" the workflow, by setting to 0 replicas, change to 1 to restart
kubectl -n sn scale deployment/psg-site --replicas=0
kubectl -n sn get pods -l app=psg-site


kubectl -n sn rollout pause deployment/psg-site
kubectl -n sn rollout resume deployment/psg-site
kubectl -n sn rollout restart deployment/psg-site # restart w/o delete
