bring cloud;
bring http;

let api = new cloud.Api();
let githubToken = new cloud.Secret(
  name: "github-token",
);
let host = "https://api.github.com";
let owner = "bear-plus";
let repo = "codeceptjs-playwright-typescript-boilerplate";
let workflow_id = "e2e-test-automation.yml";
let endpoint = "repos/{owner}/{repo}/actions/workflows/{workflow_id}/dispatches";

api.get("/trigger", inflight (req: cloud.ApiRequest): cloud.ApiResponse => {
 let token = githubToken.value();

  let response = http.post("{host}/{endpoint}", {
    headers: {
      "Authorization": "Bearer {token}",
      "Accept": "application/vnd.github+json",
      "X-GitHub-Api-Version": "2022-11-28",
    },
    body: Json.stringify({ "ref": "main" }),
  });
  if response.status == 204 {
    return cloud.ApiResponse {
      status: 200,
      body: "E2E pipeline triggered successfully.",
    };
  }
  return cloud.ApiResponse {
    status: response.status,
    body: response.body,
  };
});
