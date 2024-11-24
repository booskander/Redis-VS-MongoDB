"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Commands = void 0;
var Commands;
(function (Commands) {
    Commands["DEPLOY"] = "terraform apply";
    Commands["CD"] = "cd";
    Commands["DESTROY"] = "terraform destroy";
    Commands["LS"] = "ls";
    Commands["SHOW_DOCKER"] = "docker ps";
    Commands["UPDATE_REDIS_NODES"] = "terraform apply -var=\"redis_replicas_count=\"";
})(Commands || (exports.Commands = Commands = {}));
