FROM registry.svc.ci.openshift.org/openshift/release:golang-1.10 AS builder
WORKDIR /go/src/github.com/zvonkok/special-resource-operator
COPY . .
RUN make build

FROM registry.svc.ci.openshift.org/openshift/origin-v4.0:base
COPY --from=builder /go/src/github.com/zvonkok/special-resource-operator/special-resource-operator /usr/bin/

RUN mkdir -p /opt/special-resource-operator/assets
COPY assets  /opt/special-resource-operator/assets

RUN useradd special-resource-operator
USER special-resource-operator
ENTRYPOINT ["/usr/bin/special-resource-operator"]
LABEL io.k8s.display-name="OpenShift Special Resource Operator" \
      io.k8s.description="This is a component of OpenShift and manages special resources." \
      io.openshift.release.operator=true
