#!/bin/bash

# Oh man, I never thought I'd go for a quick'n'dirty build & scp solution, but I
# really don't feel like writing k8s manifests today and hack, this server is
# just haning around anyway..

rm -rf public

hugo

rsync -avh --del public/ sherlock4.geertjohan.net:/srv/hover.build/
