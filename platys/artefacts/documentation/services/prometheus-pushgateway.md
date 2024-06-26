# Prometheus Pushgateway

The Prometheus Pushgateway exists to allow ephemeral and batch jobs to expose their metrics to Prometheus. Since these kinds of jobs may not exist long enough to be scraped, they can instead push their metrics to a Pushgateway. The Pushgateway then exposes these metrics to Prometheus.

**[Website](https://prometheus.io/)** | **[Documentation](https://github.com/prometheus/pushgateway)** | **[GitHub](https://github.com/prometheus/pushgateway)**

## How to enable?

```
platys init --enable-services PROMETHEUS,PROMETHEUS_PUSHGATEWAY	
platys gen
```

## How to use it?
