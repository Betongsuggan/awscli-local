{
  lib,
  python3Packages,
  src,
}:

# `awslocal` runs the `aws` CLI found on PATH against LocalStack
python3Packages.buildPythonApplication {
  pname = "awscli-local";
  version = "0.22.0";
  inherit src;

  pyproject = true;
  build-system = [ python3Packages.setuptools ];
  dependencies = [ python3Packages.localstack-client ];

  postInstall = "rm $out/bin/awslocal.bat";

  # Upstream ships only the `awslocal` script and no tests; check that its
  # dependency resolves
  pythonImportsCheck = [ "localstack_client" ];

  meta = {
    description = "Thin wrapper around the AWS CLI for use with LocalStack";
    homepage = "https://github.com/localstack/awscli-local";
    license = lib.licenses.asl20;
    mainProgram = "awslocal";
  };
}
