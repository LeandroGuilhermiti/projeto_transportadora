require "test_helper"

class PackagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @package = packages(:one)
  end

  test "should get index" do
    get packages_url
    assert_response :success
  end

  test "should get new" do
    get new_package_url
    assert_response :success
  end

  test "should create package" do
    assert_difference("Package.count") do
      post packages_url, params: { package: { codigo_rastreio: @package.codigo_rastreio, destinatario: @package.destinatario, dimensoes: @package.dimensoes, driver_id: @package.driver_id, endereco: @package.endereco, peso: @package.peso, status: @package.status } }
    end

    assert_redirected_to package_url(Package.last)
  end

  test "should show package" do
    get package_url(@package)
    assert_response :success
  end

  test "should get edit" do
    get edit_package_url(@package)
    assert_response :success
  end

  test "should update package" do
    patch package_url(@package), params: { package: { codigo_rastreio: @package.codigo_rastreio, destinatario: @package.destinatario, dimensoes: @package.dimensoes, driver_id: @package.driver_id, endereco: @package.endereco, peso: @package.peso, status: @package.status } }
    assert_redirected_to package_url(@package)
  end

  test "should destroy package" do
    assert_difference("Package.count", -1) do
      delete package_url(@package)
    end

    assert_redirected_to packages_url
  end
end
