# CI/CD Pipeline Demo Script

## How to Trigger the Pipeline:

### Option 1: Push to Master (Full Deployment)
```bash
# Make a small change to trigger pipeline
echo "# Test commit - \$(date)" >> README.md
git add README.md
git commit -m "test: Trigger CI/CD pipeline"
git push origin master
