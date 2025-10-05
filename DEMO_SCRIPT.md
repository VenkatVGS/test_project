# CI/CD Pipeline Demo Script

## How to Trigger the Pipeline:

### Push to Master (Full Deployment)
```bash
# Make a small change to trigger pipeline
echo "# Test commit - \$(date)" >> README.md
git add README.md
git commit -m "test: Trigger CI/CD pipeline"
git push origin master

# Test main endpoint - returns SSM parameter
kubectl run test-pod --image=curlimages/curl --rm -it --restart=Never -- curl http://hello-world:8080/
# ✅ Expected: "<h1>Hello from SSM Parameter Store!</h1><p>Running on EKS</p>"

# Test health endpoint - returns JSON status
kubectl run test-pod --image=curlimages/curl --rm -it --restart=Never -- curl http://hello-world:8080/health
# ✅ Expected: {"status":"healthy","timestamp":"..."}
