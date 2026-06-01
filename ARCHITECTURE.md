Markdown


# StartTech Full-Stack Application Architecture

## Overview
This document details the production-ready infrastructure and application architecture for the StartTech Full-Stack deployment.

## System Topology Diagram Flow
User ──> CloudFront CDN ──> AWS S3 Bucket (React Frontend Files)
User ──> Application Load Balancer (ALB) ──> Auto Scaling Group (EC2 Private Subnet)
│
├──> Redis (ElastiCache Cluster)
└──> MongoDB (MongoDB Atlas cloud)


## Component Breakdowns

### 1. Frontend Layer
* **Hosting:** AWS S3 configured for Static Website Hosting.
* **Delivery:** Amazon CloudFront acts as a global Content Delivery Network (CDN) enforcing SSL and caching static assets.

### 2. Backend Compute Layer
* **Application API:** Built using Golang, multi-stage built inside high-performance Docker containers.
* **Orchestration:** Managed by an **AWS Auto Scaling Group (ASG)** spanning multiple availability zones inside private subnets.
* **Traffic Routing:** An **AWS Application Load Balancer (ALB)** exposes public entry points and balances loads across active private target groups.

### 3. Data & Session Persistence
* **Database:** MongoDB Atlas cloud cluster handle relational/document persistence securely.
* **Caching:** AWS ElastiCache (Redis cluster) handles real-time application caching and system state sessions.
