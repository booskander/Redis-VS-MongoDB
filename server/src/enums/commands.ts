export enum Commands {
    DEPLOY = 'terraform apply',
    CD = 'cd',
    DESTROY = 'terraform destroy',
    LS = 'ls',
    SHOW_DOCKER = 'docker ps',
    UPDATE_REDIS_NODES = 'terraform apply -var="redis_replicas_count="'
}