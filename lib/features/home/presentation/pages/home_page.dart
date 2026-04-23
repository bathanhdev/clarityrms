// UI_TOKENS_IGNORE
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clarityrms/core/global_state/auth/auth_cubit.dart';
import 'package:clarityrms/features/home/presentation/cubit/home_cubit.dart';
import 'package:clarityrms/features/home/presentation/cubit/home_state.dart';
import 'package:clarityrms/shared/widgets/flow_menu.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _performLogout(BuildContext context) {
    // Gọi hàm logout của Global AuthCubit (đã được cung cấp ở cấp MyApp)
    context.read<AuthCubit>().logout();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Cung cấp HomeCubit Cục bộ (Screen-Local Scope)
    // Cubit này sẽ tự động bị dispose khi HomePage bị loại bỏ.
    return BlocProvider(
      create: (_) => HomeCubit()..fetchData(), // Gọi fetchData khi khởi tạo
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Trang Chủ'),
          automaticallyImplyLeading: false,
          actions: [
            // Nút Đăng xuất - Vẫn sử dụng Global AuthCubit
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _performLogout(context),
              tooltip: 'Đăng xuất',
            ),
          ],
        ),
        floatingActionButton: FlowMenu(
          actions: [
            FlowMenuAction(
              icon: const Icon(Icons.camera),
              onPressed: () {},
              tooltip: 'Camera',
            ),
            FlowMenuAction(
              icon: const Icon(Icons.photo),
              onPressed: () {},
              tooltip: 'Ảnh',
            ),
            FlowMenuAction(
              icon: const Icon(Icons.video_call),
              onPressed: () {},
              tooltip: 'Video',
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Chào mừng! (Global State ổn định)',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50),

              // 2. Sử dụng BlocBuilder cho trạng thái cục bộ
              _buildLocalCounterSection(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget riêng để hiển thị và quản lý Bộ đếm cục bộ
  Widget _buildLocalCounterSection() {
    return BlocBuilder<HomeCubit, HomeState>(
      // Chỉ rebuild khi counter hoặc trạng thái loading thay đổi
      buildWhen: (previous, current) =>
          previous.counter != current.counter ||
          previous.isDataLoading != current.isDataLoading,

      builder: (context, state) {
        if (state.isDataLoading) {
          return const CircularProgressIndicator();
        }

        // Lấy HomeCubit instance bằng context.read (chỉ để gọi hàm)
        final homeCubit = context.read<HomeCubit>();

        return Column(
          children: [
            const Text(
              'Trạng thái cục bộ (HomeCubit):',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Bộ đếm: ${state.counter}',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: homeCubit.decrementCounter,
                  heroTag: 'decrementBtn',
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: homeCubit.incrementCounter,
                  heroTag: 'incrementBtn',
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
