import os
import pytest
from moto import mock_ssm
from typing import List, Dict
# (Apr 2023) moto does not support list_associations()/start_associations_once(), must be manually mocked in each test case
#   test approach using monkeypatch adapted from https://stackoverflow.com/a/70127210

class TestState:
    ssmclient_list_associations_call = None
    ssmclient_start_associations_call = None

@pytest.fixture
def state():
    return TestState()

@pytest.fixture
def mock_aws_environment(autouse=True): # TODO FIXME for reasons I don't understand, autouse=True doesn't seem to work? Therefore injected manually in each test
    # https://docs.getmoto.org/en/latest/docs/getting_started.html#how-do-i-avoid-tests-from-mutating-my-real-infrastructure
    # https://boto3.amazonaws.com/v1/documentation/api/latest/guide/configuration.html#using-environment-variables
    os.environ["AWS_ACCESS_KEY_ID"]     = "testing"
    os.environ["AWS_SECRET_ACCESS_KEY"] = "testing"
    os.environ["AWS_SECURITY_TOKEN"]    = "testing"
    os.environ["AWS_SESSION_TOKEN"]     = "testing"
    os.environ["AWS_DEFAULT_REGION"]    = "eu-west-2"

@mock_ssm
def test_apply_association_lambda_happy_path(state: TestState, monkeypatch, mock_aws_environment):
    # setup
    def ssmclient_list_associations_mock(AssociationFilterList: List) -> Dict:
        state.ssmclient_list_associations_call = AssociationFilterList
        return { "Associations" : [ { "AssociationId" : "assn_1"}]} # return one association
    def ssmclient_start_associations_once_mock(AssociationIds: List) -> None:
        state.ssmclient_start_associations_call = AssociationIds
        return None # success
    from critical_patching import apply_association_function # import after AWS env setup (accept default region)
    monkeypatch.setattr(apply_association_function.ssm_client, "list_associations", ssmclient_list_associations_mock)
    monkeypatch.setattr(apply_association_function.ssm_client, "start_associations_once", ssmclient_start_associations_once_mock)
    # invoke lambda, assert results
    assert apply_association_function.lambda_handler(event={"patch_group": "PatchGroup1"}, context=None) == "assn_1"
    assert state.ssmclient_list_associations_call == [{ "key" : "AssociationName", "value": "patchgroup1_patch_baseline_install"}]
    assert state.ssmclient_start_associations_call == ["assn_1"]

@mock_ssm
def test_apply_association_lambda_no_listed_associations_throws_exception(state: TestState, monkeypatch, mock_aws_environment):
    # setup
    def ssmclient_list_associations_mock(AssociationFilterList: List) -> Dict:
        state.ssmclient_list_associations_call = AssociationFilterList
        return { "Associations" : [] } # empty list associations
    from critical_patching import apply_association_function # import after AWS env setup (accept default region)
    monkeypatch.setattr(apply_association_function.ssm_client, "list_associations", ssmclient_list_associations_mock)
    # invoke lambda, assert results
    with pytest.raises(IndexError, match="list index out of range") as e_context:
        assert apply_association_function.lambda_handler(event={"patch_group": "PatchGroup1"}, context=None) is None
    assert state.ssmclient_list_associations_call == [{ "key" : "AssociationName", "value": "patchgroup1_patch_baseline_install"}]
    assert state.ssmclient_start_associations_call is None
